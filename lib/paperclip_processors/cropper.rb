module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        cmd = super.join(" ").sub(/ -crop \S+/, '')
        puts cmd + ' ---- '
        cmd =  crop_command + cmd
        puts cmd
        cmd.split(" ")
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        " -crop '#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}' "
      end
    end
  end
end

