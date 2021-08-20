table 50103 TITGoCatalogUpdatedBrands
{

    CaptionML = ENU = 'Updated Brands Table';

    fields
    {

        field(1; "url"; Text[250])
        {
            CaptionML = ENU = 'URL';
        }
        field(2; "type"; Text[250])
        {
            CaptionML = ENU = 'product by brand';
        }
        field(3; "state_name"; Text[250])
        {
            CaptionML = ENU = 'state name';
        }
        field(4; "state_code"; Integer)
        {
            CaptionML = ENU = 'state code';
        }
        field(5; "id"; Code[20])
        {
            CaptionML = ENU = 'brand code';
        }
        field(6; "deleted"; Code[20])
        {
            CaptionML = ENU = 'deleted';
        }
        field(7; "date"; Text[20])
        {
            CaptionML = ENU = 'date';
        }
        field(8; "contract"; Text[20])
        {
            CaptionML = ENU = 'contract';
        }
        field(9; "brand_name"; Text[20])
        {
            CaptionML = ENU = 'brand_name';
        }
        field(10; "api_version"; Text[20])
        {
            CaptionML = ENU = 'api version';
        }
        field(11; "active"; Text[20])
        {
            CaptionML = ENU = 'active';
        }
        field(12; Actualizar; Boolean)
        {
            CaptionML = ENU = 'Actualizar';
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
