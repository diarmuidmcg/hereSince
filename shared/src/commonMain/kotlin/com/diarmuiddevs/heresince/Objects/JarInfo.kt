package com.diarmuiddevs.heresince.Objects


class JarInfo(
    val jarId:String,
    val jarOwnerName:String,
    val jarOwnerUserId:String,
    val jarContentName:String,
    val hereSince:String,
//    user determines what info they store -> ingredients, description, etc
    val otherInfo:Any,
    )  {

}