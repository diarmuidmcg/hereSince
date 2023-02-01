package com.diarmuiddevs.heresince.model.entity

import io.realm.kotlin.ext.realmListOf
import io.realm.kotlin.ext.realmSetOf
import io.realm.kotlin.types.ObjectId
import io.realm.kotlin.types.RealmList
import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.RealmSet
import io.realm.kotlin.types.annotations.PrimaryKey

enum class DataTypes {
    BOOL,
    STRING,
    DATE
}

open class JarAdditionalInfo(
    var name: String = "",
    var content: String = "",
    var type: Enum<DataTypes> = DataTypes.STRING
) :RealmObject {
    constructor() : this("", "") // Empty constructor for Realm
    constructor(copyAddInfo: JarAdditionalInfo) : this() {
       name = copyAddInfo.name
        content = copyAddInfo.content
        type = copyAddInfo.type
    }
}

open class Jar(
    @PrimaryKey
    var _id: String = ObjectId.create().toString(),
    var hereSince: String = "",
    var jarContentName: String = "",
    var jarOwnerName: String = "",
    var jarOwnerUserId: String? = null,
    var additionalInfo: MutableSet<JarAdditionalInfo> = mutableSetOf(),
    var extraInfo: MutableList<JarAdditionalInfo> = mutableListOf()
) :RealmObject {
    constructor() : this(
        _id = ObjectId.create().toString(),
    ) // Empty constructor for Realm

    constructor(copyJar: Jar) : this() {
        _id = copyJar._id
        hereSince = copyJar.hereSince
        jarContentName = copyJar.jarContentName
        jarOwnerName = copyJar.jarOwnerName
        jarOwnerUserId = copyJar.jarOwnerUserId
        additionalInfo = copyJar.additionalInfo
        extraInfo = copyJar.extraInfo
    }
}

