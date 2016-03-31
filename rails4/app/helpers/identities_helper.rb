module IdentitiesHelper
  def copy_identity_path(identity)
    url_for controller: 'identities', action: 'copy', id: identity.id 
  end
end
