class AddPostsCountToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :posts_count, :integer, default: 0
    
    group_ids_with_posts = Set.new
    Post.all.each {|post| group_ids_with_posts << post.group_id}
    group_ids_with_posts.each do |group_id|
      Group.reset_counters(group_id, :posts)
    end
  end
end
