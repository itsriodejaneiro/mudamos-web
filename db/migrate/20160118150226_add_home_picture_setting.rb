class AddHomePictureSetting < ActiveRecord::Migration
  def up
    url = 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/Floresta_1.jpg'

    Setting.create(
      key: 'home_picture',
      picture: url
    )
  end

  def down
    Setting.find_by_key('home_picture').really_destroy!
  end
end
