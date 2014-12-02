require 'aws-sdk'

class DailyBuildManager

  DAILY_BUILD_TYPE = "latest"
  DAILY_BUILD_NAME = "build"
  RELEASE_BUILD_TYPE = "release"
  RELEASE_BUILD_NAME = "release"

  def initialize (bucket)
    @bucket = bucket
    @s3 = AWS::S3.new
    @s3_client = AWS::S3::Client.new({ :region => "us-east-1" })
    @s3_bucket = AWS::S3::Bucket.new({ :name => bucket, :region => "us-east-1" })
  end

  def list_all_buckets
    puts "all buckets in S3: "
    @s3.buckets.each do |bucket|
      puts bucket.name
    end

    #puts "all objects in katt-packages: "
    objects = @s3_client.list_objects({ :bucket_name => "katt-packages" })
    #puts objects 

    #puts "all contents in katt-packages: "
    #puts objects[:contents]

#    puts "contents of desired bucket: "
#    bucket_objects_collection = @s3_bucket.objects
#    puts bucket_objects_collection
    
#    bucket_objects_collection.each do |package|
#      puts package
#    end
  end

  def list_bucket_objects (bucket, path)
    objects = @s3_client.list_objects({ :bucket_name => bucket })

    puts "all contents in #{bucket}/#{path}: "
    packages = objects[:contents].select { |s| s[:key].downcase.start_with?(path) }
    packages.each do |package|
      puts package[:key]
    end
  end

  def get_bucket_objects (bucket, path)
    objects = @s3_client.list_objects({ :bucket_name => bucket })
    packages = objects[:contents].select { |s| s[:key].downcase.start_with?(path) }
    
    return packages
  end

  def get_desired_packages (bucket, path, build_type)
    desired_packages = Array.new

    package_prefix = reconcile_package_type (build_type)
    all_packages = get_bucket_objects(bucket, path)
        
    all_packages.each do |package|
      if package[:key].include?(package_prefix)        
        desired_packages.push(package)
      end
    end

    puts "all #{build_type} packages in #{bucket}/#{path}, sorted by date: "
    sorted_packages = desired_packages.sort_by{ |package| package[:last_modified] }
    sorted_packages.each do |pkg|
      puts pkg[:key]
      puts pkg[:last_modified].to_s
      puts ""
    end

    return sorted_packages
  end

  def reconcile_package_type (build_type)        
    if build_type.downcase.eql?(DAILY_BUILD_TYPE)
      return DAILY_BUILD_NAME
    elsif build_type.downcase.eql?(RELEASE_BUILD_TYPE)
      return RELEASE_BUILD_NAME
    else
      puts "Invalid build type!"
    end
  end
end
