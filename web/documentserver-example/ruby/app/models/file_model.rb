class FileModel

  attr_accessor :file_name, :mode, :user_ip, :lang, :uid, :uname

  def initialize(attributes = {})
    @file_name = attributes[:file_name]
    @mode = attributes[:mode]
    @user_ip = attributes[:user_ip]
    @lang = attributes[:lang]
    @user_id = attributes[:uid]
    @user_name = attributes[:uname]
  end

  def desktop_type
    @mode != 'embedded'
  end

  def file_ext
    File.extname(@file_name)
  end

  def file_uri
    DocumentHelper.get_file_uri(@file_name)
  end

  def document_type
    FileUtility.get_file_type(@file_name)
  end

  def key
    uri = DocumentHelper.cur_user_host_address(nil) + '/' + @file_name
    ServiceConverter.generate_revision_id(uri)
  end

  def callback_url
    DocumentHelper.get_callback(@file_name)
  end

  def cur_user_host_address
    DocumentHelper.cur_user_host_address(nil)
  end

  def get_config
    config = {
      :type => desktop_type ? "desktop" : "embedded",
      :documentType => document_type,
      :document => {
        :title => @file_name,
        :url => file_uri,
        :fileType => file_ext.delete("."),
        :key => key,
        :info => {
          :author => "Me",
          :created => Time.now.to_s,
        },
        :permissions => {
          :edit => DocumentHelper.edited_exts.include?(file_ext),
          :download => true
        }
      },
      :editorConfig => {
        :mode => (DocumentHelper.edited_exts.include? file_ext) && @mode != "view" ? "edit" : "view",
        :lang => @lang ? @lang : "en",
        :callbackUrl => callback_url,
        :user => {
          :id => @user_id ? @user_id : "uid-0",
          :name => @user_name ? @user_name : "Jonn Smith"
        },
        :embedded => {
          :saveUrl => file_uri,
          :embedUrl => file_uri,
          :shareUrl => file_uri,
          :toolbarDocked => "top"
        },
      }
    }
    return config
  end

end