page 50100 TITItemPicture
{
    SourceTable = "Nonstock Item";
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = True;
    Caption = 'Non-stock Item Picture';
    PageType = CardPart;

    layout
    {
        area(Content)
        {

            field(Picture; rec.Picture)
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the item.';
            }

        }
    }

}