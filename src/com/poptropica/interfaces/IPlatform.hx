package com.poptropica.interfaces;

interface IPlatform {
    function getInstance(_class : Class<Dynamic>, vo : Dynamic = null) : Dynamic ;
    function checkClass(_class : Class<Dynamic>) : Bool ;
}