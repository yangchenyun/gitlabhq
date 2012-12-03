class ProjectUpdateContext < BaseContext
  def execute(role = :default)
    namespace_id = params[:project].delete(:namespace_id)

    if namespace_id.present?
      if namespace_id == Namespace.global_id
        if project.namespace.present?
          # Transfer to global namespace from anyone
          project.transfer(nil)
        end
      elsif namespace_id.to_i != project.namespace_id
        # Transfer to someone namespace
        namespace = Namespace.find(namespace_id)
        project.transfer(namespace)
      end
    end

    project.update_attributes(params[:project], as: role)
  end
end

