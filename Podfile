use_frameworks!
target 'Checklists' do

pod 'RealmSwift'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

end


target 'ChecklistsTests' do

pod 'RealmSwift'

end

target 'ChecklistsUITests' do

pod 'RealmSwift'

end

