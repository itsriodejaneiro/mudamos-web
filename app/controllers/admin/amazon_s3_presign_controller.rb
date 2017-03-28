class Admin::AmazonS3PresignController < Admin::ApplicationController
  def s3_service
    @s3_service ||= AwsService::S3.new
  end

  def video
    url = s3_service.presign_video(params.require(:filename))
    render json: { url: url }
  end
end
