class PermissionsController < ApplicationController
  before_action :ensure_json_request

  def ensure_json_request
    return if params[:format] == "json" || request.headers["Accept"] =~ /json/
    render :nothing => true, :status => 406
  end

  def show
    # Returns a JSON object describing the object's ACL
    path = "/" + params[:filepath]
    file = PosixFile.new(path)
    ret = {
      mode: file.stat.mode
    }
    if Gem::Specification::find_all_by_name('acl').any?
      require("acl")
      ret["acl"] = ACL.from_file(path).to_text
      if file.directory?
        ret["default_acl"] = ACL.default(path).to_text
      end
    end
    render json: ret
  end

  def update
  end
end
