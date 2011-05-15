# Load the rails application
require File.expand_path('../application', __FILE__)

SITE_NAME = {"" => "GoldenCMS"}
SITE = "GoldenCMS"

TEMPLATES = {"Home" => "home", "Inside" => "inside", "Full" => "full"}
DEFAULT_TEMPLATE = 'inside'
CALENDAR_TEMPLATE = 'full'

RESERVED_SHORTCUTS = { 
  :home => "home", 
  :inventory => "inventory", 
  :categories => "inventory", 
  :blogs => "blogs", 
  :calendars => "calendars", 
  :items => "items"
}

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
