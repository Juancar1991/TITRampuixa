page 50101 TITBrandUpdate
{
    UsageCategory = Lists;
    ApplicationArea = Basic, Suite, Service;
    SourceTable = TITGoCatalogUpdatedBrands;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = True;
    Caption = 'Brand Update List';
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
                    ToolTip = 'Identifier of the brand';
                }
                field(brand_name; rec.brand_name)
                {
                    CaptionML = ENU = 'Brand Name';
                    ToolTip = 'Name of the brand';
                }
                field(state_name; rec.state_name)
                {
                    CaptionML = ENU = 'State Name';
                }
                field(Actualizar; rec.Actualizar)
                {
                    CaptionML = ENU = 'Actualizar';
                    Editable = true;
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
                field(contract; rec.contract)
                {
                    CaptionML = ENU = 'Contract';
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