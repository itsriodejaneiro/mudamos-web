class ChartableCache

  def self.clear_cache cycle
    @cycle = cycle

    Rails.cache.delete("#{@cycle.slug}_user_profile_count_in_range")
    Rails.cache.delete("#{@cycle.slug}_user_gender_count_in_range")
    Rails.cache.delete("#{@cycle.slug}_user_age_count_in_range")
    Rails.cache.delete("#{@cycle.slug}_user_state_count_in_range")
    Rails.cache.delete("#{@cycle.slug}_subjects_comments_region_count_in_range")
    Rails.cache.delete("#{@cycle.slug}_subjects_users_region_count_in_range")
    Rails.cache.delete("#{@cycle.slug}_subjects_users_profile_count_in_range")
    Rails.cache.delete("#{@cycle.slug}_user_profile_anonymous_count_in_range")
    Rails.cache.delete("#{@cycle.slug}_subjects_users_profile_anonymous_count_in_range")
  end

  def self.set_cache range_start, range_end, cycle
    @cycle = cycle

    Rails.cache.fetch("#{@cycle.slug}_user_profile_count_in_range") do
      to_series @cycle.user_profile_count_in_range(range_start, range_end), 'Setores', cycle, 'pie'
    end

    Rails.cache.fetch("#{@cycle.slug}_user_gender_count_in_range") do
      to_series @cycle.user_gender_count_in_range(range_start, range_end), 'Gêneros', cycle, 'pie'
    end

    Rails.cache.fetch("#{@cycle.slug}_user_age_count_in_range") do
      to_series @cycle.user_age_count_in_range(range_start, range_end), 'Idade', cycle, 'age'
    end

    Rails.cache.fetch("#{@cycle.slug}_user_state_count_in_range") do
      to_series @cycle.user_state_count_in_range(range_start, range_end), 'Região', cycle, 'pie'
    end


    Rails.cache.fetch("#{@cycle.slug}_subjects_comments_region_count_in_range") do
      @cycle.subjects.map do |s|
        {
          subject_id: s.id,
          subject_name: s.title,
          series: to_series(s.comment_state_count_in_range(range_start, range_end), 'Comentários', cycle, 'pie')
        }
      end
    end

    Rails.cache.fetch("#{@cycle.slug}_subjects_users_region_count_in_range") do
      @cycle.subjects.map do |s|
        {
          subject_id: s.id,
          subject_name: s.title,
          series: to_series(s.user_state_count_in_range(range_start, range_end), 'Usuários', cycle, 'pie')
        }
      end
    end

    Rails.cache.fetch("#{@cycle.slug}_subjects_users_profile_count_in_range") do
      @cycle.subjects.map do |s|
        {
          subject_id: s.id,
          subject_name: s.title,
          series: to_series(s.user_profile_count_in_range(range_start, range_end), 'Usuários', cycle, 'pie')
        }
      end
    end

    # @subjects_likes_and_dislikes_count_in_range = @cycle.subjects.map do |s|
    #   {
    #     subject_id: s.id,
    #     subject_name: s.title,
    #     series: to_series(s.likes_and_dislikes_count_in_range(range_start, range_end), 'Usuários', 'line')
    #   }
    # end

    Rails.cache.fetch("#{@cycle.slug}_user_profile_anonymous_count_in_range") do
      to_series(@cycle.user_anonymous_in_range(range_start, range_end), 'Identificados x Anônimos', cycle, 'pie-anonymous')
    end

    Rails.cache.fetch("#{@cycle.slug}_subjects_users_profile_anonymous_count_in_range") do
      @cycle.subjects.map do |s|
        {
          subject_id: s.id,
          subject_name: s.title,
          series: to_series(s.user_anonymous_in_range(range_start, range_end), 'Identificados x Anônimos', cycle, 'pie-anonymous')
        }
      end
    end

    return
  end

  private

    def self.to_series hash, name, cycle, type = 'pie'
      r, g, b = @cycle.color.hex_to_rgb
      base_color = "#{r},#{g},#{b}"
      grey_color = "87,87,87"
      colors = ["rgba(#{base_color},1)", "rgba(#{base_color},0.5)", "rgba(#{base_color},0.2)", "rgba(#{grey_color},0.75)", "rgba(#{grey_color},0.5)", "rgba(#{grey_color},0.25)"]

      case type
      when 'pie'
        [{
          name: name,
          colorByPoint: true,
          data: hash.map do |k, v|
            {
              name: k,
              marker: {
                symbol: 'circle'
              },
              y: v.values.sum
            }
          end
        }].to_json
      when 'pie-multiple'
        counter = -1
        sizes = ['42%', '52%', '64%', '76%', '88%']

        total = hash.values.map { |x| x.values.sum }.sum

        hash.sort_by { |k, v| v.sum }.to_h.map do |k, v|
          {
            name: k,
            data: [my_total = v.values.sum, total - my_total],
            size: '90%',
            innerSize: sizes[(counter += 1)],
            borderColor: '#e0e0e0',
            borderWidth: 2,
            dashStyle: 'shortdot',
            colors: [colors[counter], "#FFF"]
          }
        end.to_json
      when 'age'
        ages = {
          '50+' => hash.select { |k, v| (Time.zone.now.year - k) > 50 }.values.map { |x| x.values.sum }.sum,
          '41 a 50' => hash.select { |k, v| (Time.zone.now.year - k) > 41 and (Time.zone.now.year - k) <= 50 }.values.map { |x| x.values.sum }.sum,
          '36 a 40' => hash.select { |k, v| (Time.zone.now.year - k) > 36 and (Time.zone.now.year - k) <= 40 }.values.map { |x| x.values.sum }.sum,
          '31 a 35' => hash.select { |k, v| (Time.zone.now.year - k) > 31 and (Time.zone.now.year - k) <= 35 }.values.map { |x| x.values.sum }.sum,
          '26 a 30' => hash.select { |k, v| (Time.zone.now.year - k) > 26 and (Time.zone.now.year - k) <= 30 }.values.map { |x| x.values.sum }.sum,
          '19 a 25' => hash.select { |k, v| (Time.zone.now.year - k) > 19 and (Time.zone.now.year - k) <= 25 }.values.map { |x| x.values.sum }.sum,
          '18-' => hash.select { |k, v| (Time.zone.now.year - k) <= 18 }.values.map { |x| x.values.sum }.sum
        }

        [{
          name: name,
          data: ages.map do |k, v|
            {
              name: k,
              y: v
            }
          end
        }].to_json
      when 'line'
        [{
          name: 'Likes',
          color: 'rgba(0, 0, 0, 0.0)',
          marker: {
            fillColor: '#3E3C6D',
            symbol: "url(#{ActionController::Base.helpers.image_path("like-chart.svg")})",
            width: 42,
            height: 42
          },
          data: hash[:likes].times.map { |x| 1 }.in_groups_of(10).map { |x| x.reject { |y| y.nil? }.sum }
        },
        {
          name: 'Dislikes',
          color: 'rgba(0, 0, 0, 0.0)',
          marker: {
            fillColor: '#3E3C6D',
            symbol: "url(#{ActionController::Base.helpers.image_path("dislike-chart.svg")})",
            width: 42,
            height: 42
          },
          data: hash[:dislikes].times.map { |x| 1 }.in_groups_of(10).map { |x| x.reject { |y| y.nil? }.sum }
        }].to_json
      when 'pie-anonymous'
        a = [
          {
            name: 'Identificados',
            colorByPoint: true,
            innerSize: '45%',
            center: [110, 120],
            showInLegend: true,
            data: []
          },
          {
            name: 'Anônimos',
            colorByPoint: true,
            innerSize: '45%',
            center: [400, 120],
            showInLegend: false,
            data: []
          }
        ]

        hash.each do |k, v|
          if k.first == true
            index = 1
          else
            index = 0
          end

          a[index][:data].push(
            {
              name: k.last,
              y: v
            }
          )
        end

        a.to_json
      end
    end

end
