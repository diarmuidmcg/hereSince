package com.diarmuiddevs.heresince.model.entity

import io.realm.kotlin.types.MutableRealmInt
import io.realm.kotlin.types.ObjectId
import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.annotations.PrimaryKey


class Jar(userId: String): RealmObject {

    // No-arg constructor required by Realm
    @Suppress("unused")
    constructor(): this("")
    @PrimaryKey
    val _id : ObjectId = ObjectId.create()
    var jarId: String = ""
    var jarOwnerName: String? = ""
    var jarOwnerUserId: String? = userId
    var jarContentName: String? = null


}