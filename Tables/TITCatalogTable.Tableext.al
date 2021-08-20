tableextension 50110 TITCatalogTable extends "Nonstock Item"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Unidades de embalaje"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Cantidad mínima de pedido"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Picture; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; PictureURL; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; Attachment; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; URL; Text[500])
        {
            DataClassification = ToBeClassified;
        }

    }

}