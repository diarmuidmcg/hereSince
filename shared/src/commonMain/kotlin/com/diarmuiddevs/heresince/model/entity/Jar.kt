package com.diarmuiddevs.heresince.model.entity

import io.realm.kotlin.types.ObjectId
import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.annotations.PrimaryKey


open class Jar(
    @PrimaryKey
    var _id: String = ObjectId.create().toString(),
    var hereSince: String? = null,
    var jarContentName: String? = null,
    var jarOwnerName: String? = null,
    var jarOwnerUserId: String? = null
) :RealmObject {
    constructor() : this(
        _id = ObjectId.create().toString(),
    ) // Empty constructor for Realm
}