require 'aws-sdk'

class DailyBuildManager

  def initialize (bucket)
  	@bucket = bucket
  	@s3 = AWS::S3.new
  end

  def list_all_buckets
    @s3.buckets.each do |bucket|      
      puts bucket.name
    end
  end

  def get_all_daily_packages
    requested_bucket = @s3.buckets[@bucket]
    requested_bucket.objects.each do |obj|
	    puts obj.key
  	end
  end

end