# Load the rails application
require File.expand_path('../application', __FILE__)

DEFAULT_CONFIG_PARAMS = { 
  "home_shortcut" => "home", 
  "inventory_shortcut" => "inventory", 
  "categories_shortcut" => "inventory", 
  "blogs_shortcut" => "blogs", 
  "calendars_shortcut" => "calendars", 
  "items_shortcut" => "items"
}

TEMPLATES = {
  "home" => {"human_name" => "Home", "positions" => 5}, 
  "inside" => {"human_name" => "Inside", "positions" => 2}, 
  "full" => {"human_name" => "Inside (No Nav)", "positions" => 1},
  "application" => {"human_name" => "Static"} # Static layout
}
HOME_PAGE_TEMPLATE = "home"
DEFAULT_TEMPLATE = "inside"

NODE_PAGE_TYPES = { 
  'blog' => {"default_layout" => "inside"},
  'calendar' => {"default_layout" => "full"},
  'category' => {"default_layout" => "inside"},
  'event' => {"default_layout" => "inside"},
  'item_page' => {"default_layout" => "inside"},
  'post' => {"default_layout" => "inside"}
}

LOG_CATEGORY = ['CODE','CACHE','DB','FILTER','PARAMS']

ELEM_TYPES = [
  ["Text"             ,   "text_elems"            ],
  ["Link"             ,   "link_elems"            ],
  ["Item"             ,   "item_elems"            ],
  ["Item List"        ,   "item_list_elems"       ],
  ["Inventory Search" ,   "item_search_elems"     ],
  ["Login"            ,   "login_elems"           ],
  ["Blog"             ,   "blog_elems"            ],
  ["Calendar"         ,   "calendar_elems"        ],
  #["Photo Gallery"    ,   "photo_gallery_elems"   ],
  ["Side Nav Menu"    ,   "side_nav_elems"        ],
  ["Image"            ,   "image_elems"           ]
]

# Initialize the rails application
GoldenCMS::Application.initialize!
