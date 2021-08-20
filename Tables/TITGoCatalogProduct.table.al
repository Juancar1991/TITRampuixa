table 50102 "TITGoCatalogProduct"
{

    fields
    {

        field(1; "api_version"; Text[250])
        {
            CaptionML = ENU = 'api_version';
        }
        field(2; "data_origin"; Text[250])
        {
            CaptionML = ENU = 'data_origin';
        }
        field(3; "brand_id"; Code[20])
        {
            CaptionML = ENU = 'brand_id';
        }
        field(4; "id"; Code[20])
        {
            CaptionML = ENU = 'id';
        }
        field(5; "unique_id"; Code[50])
        {
            CaptionML = ENU = 'unique_id';
        }
        field(6; "part_code"; Text[250])
        {
            CaptionML = ENU = 'part_code';
        }
        field(7; "brand_name"; Code[10])
        {
            CaptionML = ENU = 'brand_name';
        }
        field(8; "entity_vat"; Text[250])
        {
            CaptionML = ENU = 'entity_vat';
        }
        field(9; "entity_name"; Text[250])
        {
            CaptionML = ENU = 'entity_name';
        }
        field(10; "entity_duns"; Text[250])
        {
            CaptionML = ENU = 'entity_duns';
        }
        field(11; "replaced_by_id"; Text[250])
        {
            CaptionML = ENU = 'replaced_by_id';
        }
        field(12; "previous_part_code"; Text[250])
        {
            CaptionML = ENU = 'previous_part_code';
        }
        field(13; "replaces_part_code"; Text[250])
        {
            CaptionML = ENU = 'replaces_part_code';
        }
        field(14; "ean"; Code[20])
        {
            CaptionML = ENU = 'ean';
        }
        field(15; "product_range_id"; Text[250])
        {
            CaptionML = ENU = 'product_range_id';
        }
        field(16; "product_range_name"; Text[250])
        {
            CaptionML = ENU = 'product_range_name';
        }
        field(17; "stock_unit_code"; Text[250])
        {
            CaptionML = ENU = 'stock_unit_code';
        }
        field(18; "stock_unit_code_un20"; Text[250])
        {
            CaptionML = ENU = 'stock_unit_code_un20';
        }
        field(19; "active"; Boolean)
        {
            CaptionML = ENU = 'active';
        }
        field(20; "deleted"; Boolean)
        {
            CaptionML = ENU = 'deleted';
        }
        field(21; "state_code"; Integer)
        {
            CaptionML = ENU = 'state_code';
        }
        field(22; "state_name"; Text[250])
        {
            CaptionML = ENU = 'state_name';
        }
        field(23; "updated_at"; Text[250])
        {
            CaptionML = ENU = 'updated_at';
        }
        field(24; "created_at"; Text[250])
        {
            CaptionML = ENU = 'created_at';
        }
        field(25; "recovered_at"; Text[250])
        {
            CaptionML = ENU = 'recovered_at';
        }
        field(26; "outdated_at"; Text[250])
        {
            CaptionML = ENU = 'outdated_at';
        }
        field(27; "url"; Text[500])
        {
            CaptionML = ENU = 'url';
        }
        field(28; "img_original"; Text[250])
        {
            CaptionML = ENU = 'img_original';
        }
        field(29; "img_original_height"; Integer)
        {
            CaptionML = ENU = 'img_original_height';
        }
        field(30; "img_original_width"; Integer)
        {
            CaptionML = ENU = 'img_original_width';
        }
        field(31; "img_original_size"; Integer)
        {
            CaptionML = ENU = 'img_original_size';
        }
        field(32; "img_high"; Text[250])
        {
            CaptionML = ENU = 'img_high';
        }
        field(33; "img_high_height"; Integer)
        {
            CaptionML = ENU = 'img_high_height';
        }
        field(34; "img_high_width"; Integer)
        {
            CaptionML = ENU = 'img_high_width';
        }
        field(35; "img_high_size"; Integer)
        {
            CaptionML = ENU = 'img_high_size';
        }
        field(36; "img_low"; Text[250])
        {
            CaptionML = ENU = 'img_low';
        }
        field(37; "img_low_height"; Integer)
        {
            CaptionML = ENU = 'img_low_height';
        }
        field(38; "img_low_width"; Integer)
        {
            CaptionML = ENU = 'img_low_width';
        }
        field(39; "img_low_size"; Integer)
        {
            CaptionML = ENU = 'img_low_size';
        }
        field(40; "img_thumb"; Text[250])
        {
            CaptionML = ENU = 'img_thumb';
        }
        field(41; "img_thumb_height"; Integer)
        {
            CaptionML = ENU = 'img_thumb_height';
        }
        field(42; "img_thumb_width"; Integer)
        {
            CaptionML = ENU = 'img_thumb_width';
        }
        field(43; "img_thumb_size"; Integer)
        {
            CaptionML = ENU = 'img_thumb_size';
        }
        field(44; "description_short"; Text[100])
        {
            CaptionML = ENU = 'description_short';
        }

        field(45; Picture; MediaSet)
        {
            CaptionML = ENU = 'Picture';
        }
        field(46; Attachment; Media)
        {
            CaptionML = ENU = 'attachment';
        }

        field(47; Price; Decimal)
        {
            CaptionML = ENU = 'Price';
        }

    }

    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }

    }

}
