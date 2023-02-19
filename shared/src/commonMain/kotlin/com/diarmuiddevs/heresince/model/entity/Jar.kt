package com.diarmuiddevs.heresince.model.entity

import io.realm.kotlin.ext.realmListOf
import io.realm.kotlin.ext.realmSetOf
import io.realm.kotlin.types.*
import io.realm.kotlin.types.annotations.PrimaryKey

enum class DataTypes {
    BOOL,
    STRING,
    DATE
}

//open class JarAdditionalInfo(
//    var name: String = "",
//    var content: String = "",
//    var type: Enum<DataTypes> = DataTypes.STRING
//) :RealmObject {
//    constructor() : this(name = "",content="") // Empty constructor for Realm
//    constructor(copyAddInfo: JarAdditionalInfo) : this() {
//       name = copyAddInfo.name
//        content = copyAddInfo.content
//        type = copyAddInfo.type
//    }
//}

// Define an embedded object (cannot have primary key)
class JarExtraInfo(
        var name: String = "",
    var content: String = "",
    var type: Enum<DataTypes> = DataTypes.STRING
) : EmbeddedRealmObject {
    constructor() : this(name = "",content="") // Empty constructor for Realm
    constructor(copyAddInfo: JarExtraInfo) : this() {
       name = copyAddInfo.name
        content = copyAddInfo.content
        type = copyAddInfo.type
    }
//    var name: String? = null
//    var content: String? = null
//    var type: Enum<DataTypes>? = null
}

open class Jar(
    @PrimaryKey
    var _id: String = ObjectId.create().toString(),
    var hereSince: String = "",
//    var dateSet: RealmInstant = RealmInstant.now(),
    var jarContentName: String = "",
    var jarOwnerName: String = "",
    var jarOwnerUserId: String? = null,
    var extraFields: RealmList<JarExtraInfo> = realmListOf()
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
    }
}

