# Bundle up our JS for single-file output
javascript_bundle(:application, %w(
  jquery-1.9.1.min
  application_init
  search_coder
  application_load
))
