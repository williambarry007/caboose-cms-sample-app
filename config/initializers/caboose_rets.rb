
Paperclip.interpolates :mls_acct do |attachment, style|  
  attachment.instance.mls_acct
end

Paperclip.interpolates :media_order do |attachment, style|  
  attachment.instance.media_order
end

CabooseRets::default_property_sort = 'current_price desc, mls_acct'
CabooseRets::use_hosted_images = true
CabooseRets::media_base_url    = 'http://www.westalabamamls.com/ListitTuscaloosa/media'
CabooseRets::agents_base_url   = 'http://www.westalabamamls.com/ListitTuscaloosa/members/agent_photos'
CabooseRets::offices_base_url  = 'http://www.westalabamamls.com/ListitTuscaloosa/members/office_photos'
  
# Start the update process
if Delayed::Job.where("handler like '%update_rets%'").count == 0
  CabooseRets::RetsImporter.delay(:run_at => 10.seconds.from_now, :queue => 'rets').update_rets
end
