class Schema < Caboose::Utilities::Schema    
  def self.schema
    {
      TrelloList => [
        [ :trello_id      , :string  ],
        [ :name           , :string  ]
      ],
      TrelloCard => [
        [ :trello_id            , :string   ],
        [ :trello_list_id       , :integer  ],
        [ :name                 , :string   ],
        [ :pos                  , :integer  ],
        [ :due                  , :datetime ],
        [ :to_do                , :boolean  , { :default => false }],
        [ :in_progress          , :boolean  , { :default => false }],
        [ :waiting_on_client    , :boolean  , { :default => false }],
        [ :waiting_on_internal  , :boolean  , { :default => false }],
        [ :quality_assurance    , :boolean  , { :default => false }],
        [ :finished             , :boolean  , { :default => false }]
      ],
      TrelloCardMember => [
        [ :trello_card_id   , :integer ],
        [ :trello_member_id , :integer ]
      ],
      TrelloMember => [
        [ :trello_id   , :string ],
        [ :avatar_hash , :string ],
        [ :full_name   , :string ],
        [ :initials    , :string ],
        [ :username    , :string ]
      ],      
      FacebookCache => [
        [ :id           , :integer ],
        [ :site_id      , :integer ],
        [ :page_name    , :string  ],
        [ :page_url     , :string  ],
        [ :profile_img  , :text    ],
        [ :post_id      , :text    ],
        [ :page_id      , :text    ],
        [ :post_url     , :text    ],
        [ :link         , :text    ],
        [ :story        , :text    ],
        [ :message      , :text    ],
        [ :picture      , :text    ],
        [ :description  , :text    ],
        [ :name         , :text    ],
        [ :post_type    , :string  ],
        [ :status_type  , :string  ],
        [ :date_created , :string  ]
      ],
      Fire => [
        [ :address               , :string   ],
        [ :latitude              , :float    ],
        [ :longitude             , :float    ],
        [ :cause                 , :string   ],
        [ :name                  , :string   ],
        [ :race                  , :string   ],
        [ :gender                , :string   ],
        [ :age                   , :string   ],
        [ :city                  , :string   ],
        [ :county                , :string   ],
        [ :responding_department , :string   ],
        [ :date                  , :datetime ]
      ],      
      InstagramCache => [
        [ :id            , :integer ],
        [ :site_id       , :integer ],
        [ :image_url     , :string  ],
        [ :link_url      , :string  ],
        [ :instagram_id  , :string  ],
        [ :username      , :string  ],
        [ :caption       , :text    ],
        [ :location      , :string  ],
        [ :date_created  , :string  ]
      ],
      Search => [
        [ :id            , :integer   ],
        [ :site_id       , :integer   ],
        [ :date_searched , :datetime  ],
        [ :query         , :string    ],
        [ :results       , :integer   ]
      ],
      Contact => [
        [ :id              , :integer  ],
        [ :site_id         , :integer  ],
        [ :sent_to         , :string   ],
        [ :date_submitted  , :datetime ],
        [ :name            , :string   ],
        [ :email           , :string   ],
        [ :subject         , :string   ],
        [ :message         , :text     ],
        [ :contacted                    , :boolean  , { :default => false }],
        [ :booked                       , :boolean  , { :default => false }]
      ],
      TwitterCache => [
        [ :id          , :integer  ],
        [ :site_id     , :integer  ],
        [ :body        , :text     ],
        [ :username    , :text     ],
        [ :tweet_id    , :string   ],
        [ :tweet_url   , :string   ],
        [ :created_at  , :datetime ]
      ],
      YoutubeCache => [
        [ :id            , :integer  ],
        [ :site_id       , :integer  ],
        [ :uploaded_at   , :datetime ],
        [ :title         , :string   ],
        [ :description   , :text     ],
        [ :video_id      , :string   ],
        [ :view_count    , :integer  ],
        [ :video_url     , :string   ],
        [ :username      , :string   ],
        [ :thumbnail_url , :string   ]
      ],
      VimeoCache => [
        [ :id            , :integer  ],
        [ :site_id       , :integer  ],
        [ :uploaded_at   , :datetime ],
        [ :title         , :string   ],
        [ :description   , :text     ],
        [ :video_id      , :string   ],
        [ :video_url     , :string   ],
        [ :username      , :string   ],
        [ :thumbnail_url , :string   ],
        [ :tags          , :text     ],
        [ :view_count    , :integer  ],
        [ :like_count    , :integer  ]
      ],
      SealyLead => [
        [ :site_name      , :string   ],
        [ :first_name     , :string   ],
        [ :last_name      , :string   ],
        [ :phone          , :string   ],
        [ :email          , :string   ],
        [ :date_submitted , :datetime ]
      ],
      SealyReferral => [
        [ :site_name      , :string   ],
        [ :your_name      , :string   ],
        [ :your_email     , :string   ],
        [ :friend_1_email , :string   ],
        [ :friend_2_email , :string   ],
        [ :friend_3_email , :string   ],
        [ :friend_4_email , :string   ],
        [ :date_submitted , :datetime ]
      ],      
      PollResponse => [
        [ :site_id              , :integer  ],
        [ :poll_block_id        , :integer  ],
        [ :poll_answer_block_id , :integer  ],
        [ :date_submitted       , :datetime ],
        [ :user_id              , :integer  ],
        [ :ip_address           , :string   ]
      ],      
      StripeDonation => [
        [ :site_id        , :integer  ],
        [ :email_address  , :string   ],
        [ :date_submitted , :datetime ],
        [ :name           , :string   ],
        [ :amount         , :decimal  ]
      ],
      MapStyle => [
        [ :alt_id         , :integer    ],
        [ :name           , :string     ],
        [ :description    , :text       ],
        [ :code           , :text       ]
      ]           
    }
  end
  
  def self.removed_columns 
    {
      Subscriber => [
        :site_id  ,
        :name     ,
        :email    ,
        :status
      ],
      FacebookCache => [
        :type
      ],
      Fire => [
        :description,
        :death_toll
      ]                  
    }
  end
  
  def self.renamed_columns
    {}
  end

  def self.indexes
  end
  
  def self.load_data
  end
end