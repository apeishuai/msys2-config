<?php if(!class_exists('raintpl')){exit;}?><?php echo '<?xml  version="1.0" encoding="UTF-8" ?>'; ?>

<OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
    <ShortName>Shaarli search - <?php echo $pagetitle;?></ShortName>
    <Description>Shaarli search - <?php echo $pagetitle;?></Description>
    <Url type="text/html" template="<?php echo $serverurl;?>?searchterm={searchTerms}" />
    <Url type="application/atom+xml" template="<?php echo $serverurl;?>feed/atom?searchterm={searchTerms}"/>
    <Url type="application/rss+xml" template="<?php echo $serverurl;?>feed/rss?searchterm={searchTerms}"/>
    <InputEncoding>UTF-8</InputEncoding>
    <Developer>Shaarli Community - https://github.com/shaarli/Shaarli/</Developer>
    <Image width="16" height="16">data:image/x-icon;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABmJLR0QA/wD/AP+gvaeTAAAHRklE
        QVRIx5WWaWxU5xWG3++7986dfYYZb+MN2xiMDRiDFePUiQsNoiwpUNpAmhInJVEqpa0oQUlbJVKq
        olaiqpLKUtOKhAJRm1BKRVWctuykpFjAgPcFx/uMl5mxPTOeuXPv3O3rjyiV0lIpfX+dc36c55xf
        70vwP9TZ2fFpSQCwT5u6unX4f0QeNLx27RoMQwfRveTd11T23M+8S9w+Z3NRma1W4Hk6/nEimFpM
        Xnun9Xpmz1MPY+feOhBi/fwAAOjq7iJEqmQqCZf5i7NvyNZ/bJPYgAjCiJc2Zmhyw68SM/T1+NlK
        uf61BPoH+tHU1PT5ACMjI8RXvACvpZ5NT0+fmrG+2TKqtDLV0BgA2AUfXS3+UtfDX2ixCf73E+oA
        rat92CTkv9fRBwEkSaLDt/JZR/v0Q7qjb8dQ5hjSqmYSOCkzBbogL+ij2RN8bik9wK88Al9tH4tG
        ow88lvb19yEyPwfGGLq6OungYD9fUlosrqwoQVVVUeOU8qE/mU0ZTq6KNvreNort+5hugkayQUgY
        qQld/u6qnVRhkciscOdOkNy5E0RnZ+e/AbwsZxAaHyORZA+prW01CTlnGppOqAcwUnCmlDAkAyin
        Dapb2t7lNeRijpwvTGlJROXugoKS+upz/S19Kj9lJjxXGY1VU49tGevt7WOCSMHTeAXclePsQts9
        Jq9oLR7rPVkHxpUYkK2c07ZDiieRNcAx3ZlNphcnsxbiMuEsXFSTZpabp+VVS17UNSV/8n7+gN75
        +C1DM6VEjkgatiz/5IOCAheiUdeyr+198keKZXLzTKYjMDk/ZzGJhkV9AiPSdWaYIAY4U7TYNJMR
        pugMqgHcXTiJqDK8ycMv2+TPWyWtKFw3KEdtJxNz8u8+/PNYIqeUgY/Oz+Z7q5X3gtqvG7qip8yM
        HqdZg5kGgwGACoQQQkEMQ2DMIFnGE04xCRQTZFaexUT6jEEImJ2njjxx9fr13hfqfULTQ4apHept
        lxf4mrqS3Tek0w1toTc1K6WcXfAwnyWH8kSkIueEhdhNrzUAv16fSCUzNwR3vr/G2lKWojMqbxF4
        FWlLPDvBR+RBNpTsNqfkV7htuUe/UVq456qdzzvFh2KjdSH0I6ODs1ps9NHcw2jMfRYcEQyOCiox
        aWR0fOQWVLFNUuOnrXJxfIPnpXLRKzocLpsJanhUU/bfjJ4gfwm/ys3JGX1cuS3UBvauLa/MBe9z
        5c/xGRdSKpiVmhhN98JK/w4DGgg4uLh8u1NfPhWbmzszeH3G1rxv3dL7+qXyGaXHJi46s4QQophp
        TKSDkHWGlAqmGCbAGAUA3sY5LlRZv3w44Dhnm0iFzbnsGfJR5E+EEsppTBVXuBptL5b8YQMlwnO+
        Z2wtea4cl8Rc3KXJ4zShRm0CFaCaGhSDwGSMlbtLhSr7FnVhKhscC4+AO3L0x5PSFBdfE9i40SE6
        xLSWRCIbJ6phIqEysqvk+2aJ0vhB1NK353zyaL3GS76NgRbVYykkt2OXuaQqMwuxkk0FT+OJpS+z
        piXPRP1KzRvz4dRvO68PaWCMEQAIDcbqFiLJtyaSA/Ef3NnMGttgvHS7mUUWw7cTMemtY/cPsw3n
        oe2+4mGXpt7VGWPJ6zOn1V2Xfaz5AxgvBzexodmeGWmCbWWTDOGpSZIIqeAe2/IYvnXgWbomUj2T
        lNlwUP7bV64lzuRIeoodqDxi1OKRs/e0i08dH/6JPWtk6KKaZd3xj2jAXkY3BvZGK1xrhZvRNktP
        fNA0ubQrxyxV4jHpSkWoXJPKYqBetxeRpgsMWwE5b/bxaYxUDSWmzCLbStqQuy02LY4/cWLsqH8i
        HYNbyEeJczkJSzH2855DwsXp932F9hXEKQSQ1UHa568iRAa3uFyeNVolMBmeIrzT4cTXm37KMuvA
        xb8XXTqiDELRgKg8h/dGWwP9iSDaIzcYJSCbA/uNR3N2sNahV/hbsSA70vEdW66tCOOpj8FRkIgU
        Q5ybLUopiTzeTpFWUoTXdR3knwQMzLANOyQX50fWhDktLeAX3UcIA2EEQHPgi6TBsrWzaLGm7emC
        H7bY+GPlV6YumiEpDhslxGBgROApz+yyhROzduIEzwngDh48iD3jO0nBRAUUXtHcoq+ZWbI5EWWa
        WTieFjoKsaVoN92T88J4vlz+asXqpb+hEcdotbdueZ47vyiqhpA2UoRQwpoLtpNHxR0382jR8RzT
        k8xYMyCMMfR33Uc8rxdrA9tpuHPyS7pPOTRPZ1arepa4rUsybiWnnU9a39ZXxdur+XoGAGMdoXLi
        M789axnfNxDr8omiDcvF1f3OhPf18efjF/nfz6PGvv6zlrlwWwYBgcBZbKH4WKHODLHEURDxbHDF
        QWGePftHUlZWjsy8guYnH2EgwORfZ5cuavEqgGhLnL6+sycvRP1Fbux/fheIn3wCCN4N/qdPMwA4
        2fYOeoe7kc6kcfCbh8n+r7YwAOjs6QCl9DNx5t7dew+MOf8CcuqqoLxlhwgAAAAASUVORK5CYII=
    </Image>
</OpenSearchDescription>
