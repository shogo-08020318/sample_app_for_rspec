FactoryBot.define do
  factory :task do
    title { 'testtitle' }
    content { 'testcontent' }
    status { :todo }
  end
end
