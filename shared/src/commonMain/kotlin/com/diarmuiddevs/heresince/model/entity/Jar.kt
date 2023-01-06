package com.diarmuiddevs.heresince.model.entity

import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.annotations.PrimaryKey


class Jar(jarId: String, userId : String = ""): RealmObject {

    // No-arg constructor required by Realm
    @Suppress("unused")
    constructor(): this("")
    @PrimaryKey
    var _id : String = jarId
    var jarId: String = jarId
    var jarOwnerName: String? = ""
    var jarOwnerUserId: String? = userId
    var jarContentName: String? = null
}
