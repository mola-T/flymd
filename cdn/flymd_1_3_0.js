var pointIdentifier = "fLyMd-mAkEr";
var pointHtmlIdentifier = "<span id=\"flymd-marker\">flymd-marker</span>";
var markdownFilename = "flymd.md";

/// This is the script for MathJax
/// Source
/// https://www.mathjax.org/
var MathJaxScript = "<script type=\"text/javascript\" src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\"></script>";

var gfmMode = false;
var autoRefresh = true;
var autoScroll = true;

function getNewContent()
{
    jQuery.get(markdownFilename, undefined, function(data) {
        var converter = new showdown.Converter();
        if (gfmMode)
        {
            converter.setOption('simplifiedAutoLink', 'true');
            converter.setOption('tables', 'true');
            converter.setOption('taskliststables', 'true');
        }
        $('#replacer').html(converter.makeHtml(data).replace(pointIdentifier, pointHtmlIdentifier));
        if (autoScroll)
            scrollToMaker();
        $("#flymd-marker").html("");
        $(".flymd-static #GFMize").css("color", "#737373");
        $(".flymd-static #MathJaxize").css("color", "#737373");
    }, "html");
}

function insertGFMContent()
{
    jQuery.get(markdownFilename, undefined, function(data) {

        $.ajax({
            type: "POST",
            dataType: "html",
            processData: false,
            url: "https://api.github.com/markdown/raw",
            data: data,
            contentType: "text/plain",
            success: function(data){
                $( "#replacer" ).html(data.replace(pointIdentifier, pointHtmlIdentifier));
                if (autoScroll)
                    scrollToMaker();
                $("#flymd-marker").html("");
                $(".flymd-static #GFMize").css("color", "#00cc44");
            }, 
            error: function(jqXHR, textStatus, error){
                console.log(jqXHR, textStatus, error);
            }
        });
    }, "html");
}

function insertMathJaxContent()
{
    jQuery.get(markdownFilename, undefined, function(data) {

        var converter = new showdown.Converter();
        if (gfmMode)
        {
            converter.setOption('simplifiedAutoLink', 'true');
            converter.setOption('tables', 'true');
            converter.setOption('taskliststables', 'true');
        }
        var converted = converter.makeHtml(data).replace(pointIdentifier, pointHtmlIdentifier);
        converted = MathJaxScript + converted;
        $('#replacer').html(converted);

        if (autoScroll)
            scrollToMaker();
        $("#flymd-marker").html("");

        $(".flymd-static #MathJaxize").css("color", "#00cc44");
        
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
        
    }, "html");
}

function refresh()
{
	setTimeout(function() {
        if (autoRefresh)
            getNewContent();
	    refresh();
	}, 300);
}

function scrollToMaker()
{
    var elt = $("#flymd-marker");
    if (elt != null && elt.length != 0)
    {
        var eltOffset = elt.offset().top;
        var windowHeight = $(window).height();
        var offset = eltOffset - (3 * windowHeight / 4);
        if (Math.abs($(window).scrollTop() - offset) > 3)
            window.scrollTo(0, offset);
    }
}

$(document).ready(function() {
    
    $('.flymd-static #AutoRefresh').click(function()
                         {
                             autoRefresh = !autoRefresh;
                             autoRefresh ?
                                 $(".flymd-static #AutoRefresh").css("color", "#00cc44"):
                                 $(".flymd-static #AutoRefresh").css("color", "#ff4d4d");
                         });
    

    $('.flymd-static #AutoScroll').click(function()
                                         {
                                             autoScroll = !autoScroll;
                                             autoScroll ?
                                                 $(".flymd-static #AutoScroll").css("color", "#00cc44"):
                                                 $(".flymd-static #AutoScroll").css("color", "#ff4d4d");
                                         });

    $('.flymd-static #GFMmode').click(function()
                                      {
                                          gfmMode = !gfmMode;
                                          gfmMode ?
                                              $(".flymd-static #GFMmode").css("color", "#00cc44"):
                                              $(".flymd-static #GFMmode").css("color", "#ff4d4d");
                                      });
    
    $('.flymd-static #GFMize').click(function()
                                     {
                                         autoRefresh = false;
                                         $(".flymd-static #AutoRefresh").css("color", "#ff4d4d");
                                         $(".flymd-static #MathJaxize").css("color", "#737373");
                                         insertGFMContent();
                                     });

    $('.flymd-static #MathJaxize').click(function()
                                     {
                                         autoRefresh = false;
                                         $(".flymd-static #AutoRefresh").css("color", "#ff4d4d");
                                         $(".flymd-static #GFMize").css("color", "#737373");
                                         insertMathJaxContent();
                                     });
    
    getNewContent();
    refresh();
});
