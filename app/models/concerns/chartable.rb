module Chartable
  extend ActiveSupport::Concern

  included do

  end

  def comments_with_user_and_profiles(start_date, end_date)
    @c ||= comments.joins{ user }.joins{ user.profile }.in_daterange(start_date, end_date)
  end

  def comment_count_in_range(start_date, end_date)
    comments_with_user_and_profiles(start_date, end_date).group("DATE_TRUNC('day', comments.created_at)").count
  end

  def comment_profile_count_in_range(start_date, end_date, month = false)
    start_date = start_date.to_date
    end_date = end_date.to_date

    c = comments_with_user_and_profiles(start_date, end_date).group('profiles.name').group("DATE_TRUNC('#{month ? 'month' : 'day'}', comments.created_at)").count

    convert_to_range c, start_date, end_date, month, :profile
  end

  def comment_state_count_in_range(start_date, end_date, month = false)
    start_date = start_date.to_date
    end_date = end_date.to_date

    c = comments_with_user_and_profiles(start_date, end_date).group('users.encrypted_state').group("DATE_TRUNC('#{month ? 'month' : 'day'}', comments.created_at)").count

    convert_to_range c, start_date, end_date, month, :encrypted_state
  end

  def users_with_profiles start_date, end_date
    @u ||= users.joins{ profile }.in_daterange(start_date, end_date)
  end

  def user_age_count_in_range(start_date, end_date, month = false)
    start_date = start_date.to_date
    end_date = end_date.to_date

    u = users_with_profiles(start_date, end_date).where('users.birthday IS NOT NULL').group("DATE_TRUNC('year', users.birthday)").group("DATE_TRUNC('#{month ? 'month' : 'day'}', users.created_at)").count

    new_h = u.dup
    new_h.each do |k, v|
      new_key = [k.first.year, k.last]
      u[new_key] = u.delete(k)
    end

    convert_to_range u, start_date, end_date, month, :birthday
  end

  def user_profile_count_in_range(start_date, end_date, month = false)
    start_date = start_date.to_date
    end_date = end_date.to_date

    u = users_with_profiles(start_date, end_date).group('profiles.name').group("DATE_TRUNC('#{month ? 'month' : 'day'}', users.created_at)").count

    convert_to_range u, start_date, end_date, month, :profile
  end

  def user_gender_count_in_range(start_date, end_date, month = false)
    user_attribute_count_in_range(start_date, end_date, :gender, month)
  end

  def user_state_count_in_range(start_date, end_date, month = false)
    user_attribute_count_in_range(start_date, end_date, :encrypted_state, month)
  end

  def likes_and_dislikes_count_in_range(start_date, end_date, month = false)
    start_date = start_date.to_date
    end_date = end_date.to_date

    comments_ids = comments.pluck(:id)

    l = Like.where{ comment_id.in(comments_ids) & (created_at >= start_date) & (created_at <= end_date) }.uniq
    d = Dislike.where{ comment_id.in(comments_ids) & (created_at >= start_date) & (created_at <= end_date) }.uniq

    {
      likes: l.count,
      dislikes: d.count
    }
  end

  def user_anonymous_in_range(start_date, end_date, month = false)
    start_date = start_date.to_date
    end_date = end_date.to_date

    u = users_with_profiles(start_date, end_date).group('users.alias_as_default').group('profiles.name').where{ (created_at >= start_date) & (created_at <= end_date) }.count
  end

  private

    def comment_attribute_count_in_range(start_date, end_date, attribute, month = false)
      start_date = start_date.to_date
      end_date = end_date.to_date

      c = comments_with_user_and_profiles(start_date, end_date).group("comments.#{attribute.to_s}").group("DATE_TRUNC('#{month ? 'month' : 'day'}', comments.created_at)").count

      convert_to_range c, start_date, end_date, month, attribute
    end

    def user_attribute_count_in_range(start_date, end_date, attribute, month = false)
      start_date = start_date.to_date
      end_date = end_date.to_date

      u = users_with_profiles(start_date, end_date).group("users.#{attribute.to_s}").group("DATE_TRUNC('#{month ? 'month' : 'day'}', users.created_at)").count

      convert_to_range u, start_date, end_date, month, attribute
    end

    def convert_to_range grouped_data, start_date, end_date, month, attribute
      h = {}
      grouped_data.map do |k, v|
        h[k.first] ||= {}
        h[k.first][k.last.to_date] = v
      end

      if [:gender].include? attribute
        array = (@genders ||= User.send(attribute.to_s.pluralize.to_sym).values.uniq)
      elsif [:encrypted_state].include? attribute
        array = (@states ||= User.where('users.encrypted_state IS NOT NULL').pluck(:encrypted_state).uniq)
      elsif [:profile].include? attribute
        array = (@profiles ||= Profile.roots.pluck(:name).uniq)
      elsif [:birthday].include? attribute
        array = (@years ||= User.where('users.birthday IS NOT NULL').pluck(:birthday).map { |x| x.year }.uniq)
      end

      array.map do |x|
        h[x] ||= {}
      end

      range = (start_date..end_date)

      if month
        range = range.map(&:beginning_of_month).uniq
      end

      new_h = h.dup
      range.each do |d|
        h.each do |k, v|
          unless v.keys.include? d
            new_h[k][d] = 0
          end
        end
      end

      # if [:birthday].include? attribute
      #   binding.pry
      # end

      if [:encrypted_state].include? attribute
        array.each do |es|
          s = User.where(encrypted_state: es).limit(1).first.state

          region = STATES_REGIONS[s]

          if region
            new_h[region] ||= {}

            new_h.delete(es).each do |k, v|
              if new_h[region][k].blank?
                new_h[region][k] = v
              else
                new_h[region][k] += v
              end
            end
          else
            new_h.delete(es)
          end
        end
      end

      if new_h.is_a? Hash
        new_h = new_h.sort.to_h

        new_h.each do |k, v|
          if v.is_a? Hash
            new_h[k] = v.sort.to_h
          end
        end
      end

      if [:gender].include? attribute
        User.send(attribute.to_s.pluralize.to_sym).each do |k, v|
          new_h[k] = new_h.delete(v)
        end
      end

      new_h
    end
end
