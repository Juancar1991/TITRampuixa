// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50100 TITItemList_Ext extends "Item list"
{
    layout
    {
        modify("No.")
        {
            Style = AttentionAccent;
            StyleExpr = MyVar;
        }

    }
    trigger OnAfterGetRecord()
    begin
        if (StrLen(rec."No.") = 10) then MyVar := true else MyVar := false
    end;

    var
        MyVar: Boolean;

}