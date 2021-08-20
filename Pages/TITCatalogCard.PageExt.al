pageextension 50102 TitCatalogCard extends "Catalog Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Item No.")
        {
            field("Unidades de embalaje"; rec."Unidades de embalaje")
            {
                ToolTip = 'Indica el número de unidades de embalaje';
                Caption = 'Packing units', Comment = 'Unidades de embalaje';
            }
            field("Cantidad mínima de pedido"; rec."Cantidad mínima de pedido")
            {
                ToolTip = 'Cantidad mínima a incluir en cada pedido';
                Caption = 'Minimum order quantity', Comment = 'Cantidad mínima de pedido';
            }
        }

        addfirst(factboxes)
        {
            part(Picture; TITItemPicture)
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "Entry No." = field("Entry No.");
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(27),
                "No." = field("Entry No.");
            }
        }
    }
    actions
    {
        addfirst(Creation)
        {
            action(update)
            {
                ToolTip = 'Update all the outdated products';
                trigger OnAction();
                var
                    Nonstockitem: Record "Nonstock Item";
                    Client: HttpClient;
                    Response: HttpResponseMessage;
                    InStr: InStream;
                    Mime: Text;
                    FileName: Text;
                begin
                    Nonstockitem.SetRange("Entry No.", rec."Entry No.");
                    if Nonstockitem.FindFirst() then begin
                        Clear(Nonstockitem.Picture);
                        Client.Get(Nonstockitem.PictureURL, Response);
                        Response.Content().ReadAs(InStr);
                        Nonstockitem.Picture.ImportStream(InStr, FileName, Mime);
                        Nonstockitem.Modify();
                    end;
                end;
            }

        }
    }
}