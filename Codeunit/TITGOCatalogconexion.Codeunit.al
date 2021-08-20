// https://media.telematel.com/export/syndication-[codigo_hash].tar.gz
codeunit 50102 "TIT GoCatalog conexion"
{
    procedure ImportProducts()

    var

        NonStock: Record "Nonstock Item";
        Product: Record TITGoCatalogProductsperBrand;
        ResponseMessage: HttpResponseMessage;
        ResponseInstream: InStream;
        DecompressedStream: OutStream;
        File: File;
        JsonText: Text;
        JsonArray: JsonArray;
        Response: JsonToken;
        ProductsperBrand: Record TITGoCatalogProductsperBrand;
        i: Integer;
        j: Integer;
        JsonToken: JsonToken;

    begin

        //Leer la tabla de marcas
        Product.Reset();
        Product.FindSet();
        i := 0;
        j := 0;
        repeat
            if Product.Actualizar then begin
                ResponseMessage := WebServiceCall(StrSubstNo('https://api.telematel.com/products?id=%1&format=json&token=957190796', Product.id));
                ResponseMessage.Content().ReadAs(JsonText);

                TempNonStock.Reset();
                TempNonStock.DeleteAll();

                //Rellenar la tabla con los productos
                if not JsonArray.ReadFrom(JsonText) then begin
                    Response.ReadFrom(JsonText);
                    InsertGoCatalog(Response);
                end;

                foreach Response in JsonArray do begin
                    Clear(JsonToken);
                    InsertProduct(Response);
                end;
                if TempNonStock.Count() > 0 then begin
                    TempNonStock.Reset();
                    TempNonStock.FindSet();
                end;
                repeat
                    j += 1;
                    NonStock.init();
                    NonStock.TransferFields(TempNonStock);
                    NonStock."Item Templ. Code" := 'GOCATALOG';
                    InsertPicture(NonStock);
                    if not NonStock.Insert(true) then
                        //    i -= 1;
                        //Message('El producto ya existía');
                        i += 1
                    else
                        Message('Insertando');
                    Proveedor(NonStock."Manufacturer code", NonStock."Vendor No.");
                //TempNonStock.Next();
                //until i > 9;
                until TempNonStock.Next() = 0;
            end;
        //    Product.Next();
        //until i > 9;
        until Product.Next() = 0;
        Message(StrSubstNo('Se han importado %1 nuevos productos', j - i));

    end;

    procedure Proveedor(Name: Text[100]; Code: Code[20]);

    var
        Proveedor: Record Vendor;
        flag: Boolean;

    begin

        flag := false;
        Proveedor.Reset();
        Proveedor.FindSet();

        repeat

            if Proveedor."No." = Code then
                flag := true;

        until Proveedor.Next() = 0;

        if flag = false then begin
            Proveedor.Init();
            Proveedor.Name := Name;
            Proveedor."No." := Code;
            Proveedor.Insert(true);

        end;

    end;

    local procedure WebServiceCall(URL: Text) ResponseMessage: HttpResponseMessage;
    var
        HttpHeaders: HttpHeaders;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
    begin
        HttpContent.GetHeaders(HttpHeaders);
        if not HttpClient.Get(URL, ResponseMessage)
        then
            Error('Ha fallado la llamada al web service.');

        if not ResponseMessage.IsSuccessStatusCode then
            error('El web service ha devuelto el siguiente mensaje de error:\' +
                  'Código de estado: %1' +
                  'Descripción: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);
    end;


    procedure InsertBrands();
    var
        ResponseMessage: HttpResponseMessage;
        ResponseInstream: InStream;
        DecompressedStream: OutStream;
        JsonToken: JsonToken;
        Response: JsonToken;
        JsonArray: JsonArray;
        JsonText: Text;
        File: File;
        i: Integer;
        j: Integer;

    begin
        // Simple web service call
        i := 0;
        j := 0;
        ResponseMessage := WebServiceCall('https://api.telematel.com/updates?by=brand&format=json&token=957190796');

        File.WriteMode(true);
        File.CreateTempFile();
        File.CreateOutStream(DecompressedStream);
        File.CreateInStream(ResponseInstream);
        ResponseMessage.Content.ReadAs(ResponseInstream);
        UnzipResponse(ResponseInstream, DecompressedStream);
        File.CreateInStream(ResponseInstream);
        ResponseInstream.Read(JsonText);

        TempUpdatedBrands.Reset();
        TempUpdatedBrands.DeleteAll();

        if not JsonArray.ReadFrom(JsonText) then begin
            Response.ReadFrom(JsonText);
            InsertBrand(Response);
        end;

        foreach Response in JsonArray do begin
            Clear(JsonToken);
            InsertBrand(Response);
        end;
        if TempUpdatedBrands.Count() > 0 then
            if Confirm(StrSubstNo('%1 nuevas marcas encontradas. Desea importarlas?', TempUpdatedBrands.Count()), false) then begin
                TempUpdatedBrands.Reset();
                TempUpdatedBrands.FindSet();
                repeat
                    if TempUpdatedBrands.active = 'true' then begin
                        j += 1;
                        UpdatedBrands.init();
                        UpdatedBrands.TransferFields(TempUpdatedBrands);
                        if not UpdatedBrands.Insert(true) then
                            i += 1;
                    end;
                until TempUpdatedBrands.next() = 0;
                Message(StrSubstNo('Se han importado %1 nuevas marcas', j - i));
            end;
    end;

    procedure InsertProducts()

    var

        ProductsperBrand: Record TITGoCatalogProductsperBrand;
        Brand: Record TITGoCatalogUpdatedBrands;
        ResponseMessage: HttpResponseMessage;
        ResponseInstream: InStream;
        DecompressedStream: OutStream;
        File: File;
        JsonText: Text;
        JsonArray: JsonArray;
        Response: JsonToken;
        i: Integer;
        j: Integer;

        JsonToken: JsonToken;

    begin

        //Leer la tabla de marcas
        Brand.Reset();
        Brand.FindSet();
        i := 0;
        j := 0;
        repeat
            ResponseMessage := WebServiceCall(StrSubstNo('https://api.telematel.com/products?brand_id=%1&format=json&token=957190796', Brand.id));

            File.WriteMode(true);
            File.CreateTempFile();
            File.CreateOutStream(DecompressedStream);
            File.CreateInStream(ResponseInstream);
            ResponseMessage.Content.ReadAs(ResponseInstream);
            UnzipResponse(ResponseInstream, DecompressedStream);
            File.CreateInStream(ResponseInstream);
            ResponseInstream.Read(JsonText);
            File.Close();

            TempProductsperBrand.Reset();
            TempProductsperBrand.DeleteAll();

            //Rellenar la tabla con los productos
            if not JsonArray.ReadFrom(JsonText) then begin
                Response.ReadFrom(JsonText);
                InsertBrand(Response);
            end;

            foreach Response in JsonArray do begin
                Clear(JsonToken);
                InsertProduct(Response);
            end;
            if TempProductsperBrand.Count() > 0 then
                TempProductsperBrand.Reset();
            TempProductsperBrand.FindSet();
            repeat
                if TempProductsperBrand.active = 'true' then begin
                    j += 1;
                    ProductsperBrand.init();
                    ProductsperBrand.TransferFields(TempProductsperBrand);
                    if not ProductsperBrand.Insert(true) then
                        i += 1;
                end;
            until TempProductsperBrand.next() = 0;
        until Brand.Next() = 0;
        Message(StrSubstNo('Se han insertado %1 nuevos productos', j - i));

    end;

    procedure InsertProduct(JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
    begin
        JsonObject := JsonToken.AsObject();
        TempProductsperBrand.Init();

        TempProductsperBrand."api_version" := COPYSTR(GetJsonToken(JsonObject, 'api_version').AsValue().AsText(), 1, 20);
        TempProductsperBrand."url" := COPYSTR(GetJsonToken(JsonObject, 'url').AsValue().AsText(), 1, 250);
        TempProductsperBrand."type" := COPYSTR(GetJsonToken(JsonObject, 'type').AsValue().AsText(), 1, 20);
        TempProductsperBrand."state_name" := COPYSTR(GetJsonToken(JsonObject, 'state_name').AsValue().AsText(), 1, 250);
        TempProductsperBrand."state_code" := GetJsonToken(JsonObject, 'state_code').AsValue().AsInteger();
        TempProductsperBrand."id" := COPYSTR(GetJsonToken(JsonObject, 'id').AsValue().AsCode(), 1, 20);
        TempProductsperBrand."deleted" := COPYSTR(GetJsonToken(JsonObject, 'deleted').AsValue().AsCode(), 1, 20);
        TempProductsperBrand."brand_id" := COPYSTR(GetJsonToken(JsonObject, 'brand_id').AsValue().AsCode(), 1, 10);
        TempProductsperBrand."brand_name" := COPYSTR(GetJsonToken(JsonObject, 'brand_name').AsValue().AsText(), 1, 20);
        TempProductsperBrand."active" := COPYSTR(GetJsonToken(JsonObject, 'active').AsValue().AsText(), 1, 20);
        TempProductsperBrand.Actualizar := true;
        TempProductsperBrand.Insert();

    end;

    procedure InsertBrand(JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
    begin
        JsonObject := JsonToken.AsObject();
        TempUpdatedBrands.Init();

        TempUpdatedBrands."api_version" := COPYSTR(GetJsonToken(JsonObject, 'api_version').AsValue().AsText(), 1, 20);
        TempUpdatedBrands."url" := COPYSTR(GetJsonToken(JsonObject, 'url').AsValue().AsText(), 1, 250);
        TempUpdatedBrands."type" := COPYSTR(GetJsonToken(JsonObject, 'type').AsValue().AsText(), 1, 20);
        TempUpdatedBrands."state_name" := COPYSTR(GetJsonToken(JsonObject, 'state_name').AsValue().AsText(), 1, 250);
        TempUpdatedBrands."state_code" := GetJsonToken(JsonObject, 'state_code').AsValue().AsInteger();
        TempUpdatedBrands."id" := COPYSTR(GetJsonToken(JsonObject, 'id').AsValue().AsCode(), 1, 20);
        TempUpdatedBrands."deleted" := COPYSTR(GetJsonToken(JsonObject, 'deleted').AsValue().AsCode(), 1, 20);
        TempUpdatedBrands."contract" := COPYSTR(GetJsonToken(JsonObject, 'contract').AsValue().AsCode(), 1, 20);
        TempUpdatedBrands."brand_name" := COPYSTR(GetJsonToken(JsonObject, 'brand_name').AsValue().AsText(), 1, 20);
        TempUpdatedBrands."active" := COPYSTR(GetJsonToken(JsonObject, 'active').AsValue().AsText(), 1, 20);
        TempUpdatedBrands.Actualizar := true;

        TempUpdatedBrands.Insert();

    end;

    procedure InsertGoCatalog(JsonToken: JsonToken);
    var
        GoCatalog: Record TITGoCatalogProduct;
        BasicInfo: JsonToken;
        BasicInfo_array: JsonArray;
        JsonObject: JsonObject;
        JsonObject2: JsonObject;
        Result: JsonToken;

    begin
        JsonObject := JsonToken.AsObject();
        Clear(Result);
        GoCatalog.init();
        GoCatalog."api_version" := COPYSTR(GetJsonToken(JsonObject, 'api_version').AsValue().AsText(), 1, 250);
        GoCatalog."data_origin" := COPYSTR(GetJsonToken(JsonObject, 'data_origin').AsValue().AsText(), 1, 250);
        GoCatalog."brand_id" := COPYSTR(GetJsonToken(JsonObject, 'brand_id').AsValue().AsCode(), 1, 20);
        GoCatalog."id" := COPYSTR(GetJsonToken(JsonObject, 'id').AsValue().AsCode(), 1, 20);
        GoCatalog."unique_id" := COPYSTR(GetJsonToken(JsonObject, 'unique_id').AsValue().AsCode(), 1, 50);
        GoCatalog."part_code" := COPYSTR(GetJsonToken(JsonObject, 'part_code').AsValue().AsText(), 1, 250);
        GoCatalog."brand_name" := COPYSTR(GetJsonToken(JsonObject, 'brand_name').AsValue().AsCode(), 1, 10);
        GoCatalog."entity_vat" := COPYSTR(GetJsonToken(JsonObject, 'entity_vat').AsValue().AsText(), 1, 250);
        GoCatalog."entity_name" := COPYSTR(GetJsonToken(JsonObject, 'entity_name').AsValue().AsText(), 1, 250);
        GoCatalog."entity_duns" := COPYSTR(GetJsonToken(JsonObject, 'entity_duns').AsValue().AsText(), 1, 250);
        GoCatalog."replaced_by_id" := COPYSTR(GetJsonToken(JsonObject, 'replaced_by_id').AsValue().AsText(), 1, 250);
        GoCatalog."previous_part_code" := COPYSTR(GetJsonToken(JsonObject, 'previous_part_code').AsValue().AsText(), 1, 250);
        GoCatalog."replaces_part_code" := COPYSTR(GetJsonToken(JsonObject, 'replaces_part_code').AsValue().AsText(), 1, 250);
        GoCatalog."ean" := COPYSTR(GetJsonToken(JsonObject, 'ean').AsValue().AsCode(), 1, 20);
        GoCatalog."product_range_id" := COPYSTR(GetJsonToken(JsonObject, 'product_range_id').AsValue().AsText(), 1, 250);
        GoCatalog."product_range_name" := COPYSTR(GetJsonToken(JsonObject, 'product_range_name').AsValue().AsText(), 1, 250);
        GoCatalog."stock_unit_code" := COPYSTR(GetJsonToken(JsonObject, 'stock_unit_code').AsValue().AsText(), 1, 250);
        GoCatalog."stock_unit_code_un20" := COPYSTR(GetJsonToken(JsonObject, 'stock_unit_code_un20').AsValue().AsText(), 1, 250);
        GoCatalog."active" := GetJsonToken(JsonObject, 'active').AsValue().AsBoolean();
        GoCatalog."deleted" := GetJsonToken(JsonObject, 'deleted').AsValue().AsBoolean();
        GoCatalog."state_code" := GetJsonToken(JsonObject, 'state_code').AsValue().AsInteger();
        GoCatalog."state_name" := COPYSTR(GetJsonToken(JsonObject, 'state_name').AsValue().AsText(), 1, 250);
        GoCatalog."updated_at" := COPYSTR(GetJsonToken(JsonObject, 'updated_at').AsValue().AsText(), 1, 250);
        GoCatalog."created_at" := COPYSTR(GetJsonToken(JsonObject, 'created_at').AsValue().AsText(), 1, 250);
        GoCatalog."recovered_at" := COPYSTR(GetJsonToken(JsonObject, 'recovered_at').AsValue().AsText(), 1, 250);
        GoCatalog."outdated_at" := COPYSTR(GetJsonToken(JsonObject, 'outdated_at').AsValue().AsText(), 1, 250);
        GoCatalog."url" := COPYSTR(GetJsonToken(JsonObject, 'url').AsValue().AsText(), 1, 500);
        GoCatalog."img_original" := COPYSTR(GetJsonToken(JsonObject, 'img_original').AsValue().AsText(), 1, 250);
        GoCatalog."img_original_height" := GetJsonToken(JsonObject, 'img_original_height').AsValue().AsInteger();
        GoCatalog."img_original_width" := GetJsonToken(JsonObject, 'img_original_width').AsValue().AsInteger();
        GoCatalog."img_original_size" := GetJsonToken(JsonObject, 'img_original_size').AsValue().AsInteger();
        GoCatalog."img_high" := COPYSTR(GetJsonToken(JsonObject, 'img_high').AsValue().AsText(), 1, 250);
        GoCatalog."img_high_height" := GetJsonToken(JsonObject, 'img_high_height').AsValue().AsInteger();
        GoCatalog."img_high_width" := GetJsonToken(JsonObject, 'img_high_width').AsValue().AsInteger();
        GoCatalog."img_high_size" := GetJsonToken(JsonObject, 'img_high_size').AsValue().AsInteger();
        GoCatalog."img_low" := COPYSTR(GetJsonToken(JsonObject, 'img_low').AsValue().AsText(), 1, 250);
        GoCatalog."img_low_height" := GetJsonToken(JsonObject, 'img_low_height').AsValue().AsInteger();
        GoCatalog."img_low_width" := GetJsonToken(JsonObject, 'img_low_width').AsValue().AsInteger();
        GoCatalog."img_low_size" := GetJsonToken(JsonObject, 'img_low_size').AsValue().AsInteger();
        GoCatalog."img_thumb" := COPYSTR(GetJsonToken(JsonObject, 'img_thumb').AsValue().AsText(), 1, 250);
        GoCatalog."img_thumb_height" := GetJsonToken(JsonObject, 'img_thumb_height').AsValue().AsInteger();
        GoCatalog."img_thumb_width" := GetJsonToken(JsonObject, 'img_thumb_width').AsValue().AsInteger();
        GoCatalog."img_thumb_size" := GetJsonToken(JsonObject, 'img_thumb_size').AsValue().AsInteger();

        BasicInfo_array := GetJsonToken(JsonObject, 'basic_information').AsArray();
        BasicInfo_array.Get(0, BasicInfo);
        JsonObject2 := BasicInfo.AsObject();
        GoCatalog."description_short" := COPYSTR(GetJsonToken(JsonObject2, 'description_short').AsValue().AsText(), 1, 100);

        if JsonObject.Contains('public_prices') then begin
            BasicInfo_array := GetJsonToken(JsonObject, 'public_prices').AsArray();
            BasicInfo_array.Get(0, BasicInfo);
            JsonObject2 := BasicInfo.AsObject();
            GoCatalog."Price" := GetJsonToken(JsonObject2, 'price').AsValue().AsDecimal();
        end;

        TempNonStock.Reset();
        TempNonStock.DeleteAll();
        TempNonStock.Init();
        //Creación de nuevo producto de catálogo
        TempNonStock."Entry No." := GoCatalog."id";
        TempNonStock."Bar Code" := GoCatalog."ean";
        TempNonStock.Description := GoCatalog."description_short";
        TempNonStock."Vendor Item No." := GoCatalog.unique_id;
        TempNonStock."Manufacturer Code" := GoCatalog.brand_name;
        TempNonStock."Vendor No." := GoCatalog.brand_id;
        Evaluate(TempNonStock."Last Date Modified", CopyStr(GoCatalog.updated_at, 1, 10));
        TempNonStock.PictureURL := GoCatalog.img_low;
        TempNonStock."Unit Price" := GoCatalog.Price;
        TempNonStock.URL := GoCatalog.url;
        TempNonStock.Insert();

    end;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    procedure InsertPicture(Nonstockitem: Record "Nonstock Item")
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
        Mime: Text;
        FileName: Text;
    begin
        if Nonstockitem.FindFirst() then begin
            Clear(Nonstockitem.Picture);
            if Client.Get(Nonstockitem.PictureURL, Response) then begin
                Response.Content().ReadAs(InStr);
                Nonstockitem.Picture.ImportStream(InStr, FileName, Mime);
                Nonstockitem.Modify();
            end;
        end;
    end;

    local procedure UnzipResponse(ResponseInStream: InStream; DecompressedStream: OutStream);
    var
        CDataCompression: Codeunit "Data Compression";
    begin
        CDataCompression.GZipDecompress(ResponseInStream, DecompressedStream);
    end;

    var
        TempUpdatedBrands: Record TITGoCatalogUpdatedBrands temporary;
        TempProductsperBrand: Record TITGoCatalogProductsperBrand temporary;
        TempNonStock: Record "Nonstock Item" temporary;
        UpdatedBrands: Record TITGoCatalogUpdatedBrands;
}