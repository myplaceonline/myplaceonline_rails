FactoryGirl.define do
  factory :phone do
    phone_model_name "MyString"
manufacturer nil
purchased "2015-09-27"
price "9.99"
operating_system 1
operating_system_version "9.99"
max_resolution_width 1
max_resolution_height 1
ram 1
num_cpus 1
num_cores_per_cpu 1
hyperthreaded false
max_cpu_speed "9.99"
cdma false
gsm false
front_camera_megapixels "9.99"
back_camera_megapixels "9.99"
notes "MyText"
owner nil
  end

end
