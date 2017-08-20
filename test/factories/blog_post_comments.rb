FactoryGirl.define do
  factory :blog_post_comment do
    blog_post nil
    comment "MyText"
    commenter_identity nil
    commenter_name "MyString"
    commenter_email "MyString"
    commenter_website "MyString"
    visit_count 1
    archived "2017-08-19 18:14:56"
    rating 1
    identity nil
  end
end
