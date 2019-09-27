class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :author

  def author
  	# Define author serialization
  	user = self.object.user
  	{
  		name: user.name,
  		email: user.email,
  		id: user.id
  	}
  end
end
