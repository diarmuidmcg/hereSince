package com.diarmuiddevs.heresince.Objects


class JarInfo(
    val jarId:String,
    var jarOwnerName:String,
    val jarOwnerUserId:String,
    var jarContentName:String,
    var hereSince:String,
//    user determines what info they store -> ingredients, description, etc
    var otherInfo:Map<String, String>,
    )  {

    fun updateJar(jarOwnerName:String?, jarContentName: String?,hereSince: String?,otherInfo: Map<String, String>?) {
        if (jarOwnerName != null) {
            this.jarOwnerName = jarOwnerName
        };
        if (jarContentName != null) {
            this.jarContentName = jarContentName
        };
        if (hereSince != null) {
            this.hereSince = hereSince
        };
        if (otherInfo != null) {
            this.otherInfo = otherInfo
        };
    }

}

