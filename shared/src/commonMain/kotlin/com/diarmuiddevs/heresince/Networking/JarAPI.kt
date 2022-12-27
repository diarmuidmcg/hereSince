package com.diarmuiddevs.heresince.Networking

import com.diarmuiddevs.heresince.Objects.JarInfo

// use Ktor


class JarAPI {

    var sampleJarInfo = JarInfo(
        jarId = "215342134",
        jarOwnerName = "Tom",
        jarOwnerUserId = "123124213",
        jarContentName = "Milk",
        hereSince = "25 December 2022",
        otherInfo = mapOf(
            "Ingredients" to "Sugar, Fat, Salt",
            "Description" to "Straight From the cow"
        )
    )

    fun getJarById(jarId:String) {}
    fun getJarsByUser(userId:String) {}

    fun createJarById(jarId:String) {}
    fun updateJarById(jarId:String) {}
    fun deleteJarById(jarId:String) {}
}