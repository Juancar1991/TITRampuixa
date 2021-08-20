page 50102 TITProductsperBrand
{
    UsageCategory = Lists;
    ApplicationArea = Basic, Suite, Service;
    SourceTable = TITGoCatalogProductsperBrand;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = True;
    Caption = 'Products per Brand List';
    PageType = List;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(id; rec.id)
                {
                    CaptionML = ENU = 'Id';
                    ToolTip = 'Identifier of the product';
                }
                field(brand_name; rec.brand_name)
                {
                    CaptionML = ENU = 'Brand Name';
                    ToolTip = 'Name of the brand';
                }
                field(Actualizar; rec.Actualizar)
                {
                    CaptionML = ENU = 'Actualizar';
                    Editable = true;
                }
                field(brand_id; rec.brand_id)
                {
                    CaptionML = ENU = 'Contract';
                }
                field(state_name; rec.state_name)
                {
                    CaptionML = ENU = 'State Name';
                }
                field(state_code; rec.state_code)
                {
                    CaptionML = ENU = 'State Code';
                }
                field(active; rec.active)
                {
                    CaptionML = ENU = 'active';
                }
                field(date; rec.date)
                {
                    CaptionML = ENU = 'Date';
                }

                field(url; rec.url)
                {
                    CaptionML = ENU = 'URL';
                }
                field(type; rec.type)
                {
                    CaptionML = ENU = 'Type';
                }
                field(api_version; rec.api_version)
                {
                    CaptionML = ENU = 'api_version';
                }


            }
        }

    }
}