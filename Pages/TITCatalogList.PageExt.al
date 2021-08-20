pageextension 50101 TitCatalogList extends "Catalog Item List"
{
    layout
    {
        // Add changes to page layout here
    }
    actions
    {
        addfirst(Processing)
        {
            action("Brands Import")
            {
                Caption = 'Brands Import';
                ToolTip = 'Actualización de las marcas de catálogo';
                Image = Web;
                ApplicationArea = All;

                trigger OnAction();
                var
                    GoCatalog: Codeunit "TIT GoCatalog conexion";
                begin
                    GoCatalog.InsertBrands();
                end;
            }
            action("Products Import")
            {
                Caption = 'Products Import';
                ToolTip = 'Actualización de los productos de catálogo';
                Image = Web;
                ApplicationArea = All;

                trigger OnAction();
                var
                    GoCatalog: Codeunit "TIT GoCatalog conexion";
                begin
                    GoCatalog.InsertProducts();
                end;
            }

            action("GoCatalog Import")
            {
                Caption = 'GoCatalog Import';
                ToolTip = 'Importación de los productos de catálogo';
                Image = Add;
                ApplicationArea = All;

                trigger OnAction();
                var
                    GoCatalog: Codeunit "TIT GoCatalog conexion";
                begin
                    GoCatalog.ImportProducts();
                end;
            }

        }
    }
}