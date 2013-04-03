# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def image?
    img_ext = %w(png jpg jpeg)
    if file.respond_to?(:extension)
      img_ext.include?(file.extension)
    else
      # Not all CarrierWave storages respond to :extension
      ext = file.path.split('.').last
      img_ext.include?(ext)
    end
  rescue
    false
  end

  def secure_url
    if self.class.storage == CarrierWave::Storage::File
      "/files/#{model.class.to_s.underscore}/#{model.id}/#{file.filename}"
    else
      url
    end
  end
end
