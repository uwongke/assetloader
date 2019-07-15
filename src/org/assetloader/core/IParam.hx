package org.assetloader.core;

/** Holds parameter data for ILoader instances. */
interface IParam {
    /** Gets parameter id. */
    var id(get, never): String;

    /** Gets value of parameter. */
    var value(get, never): Dynamic;
}