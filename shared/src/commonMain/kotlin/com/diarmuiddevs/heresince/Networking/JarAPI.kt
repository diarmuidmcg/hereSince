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

    var lotsOfSampleJars = listOf<JarInfo>(
        JarInfo(
            jarId = "215342134",
            jarOwnerName = "Tom",
            jarOwnerUserId = "123124213",
            jarContentName = "Milk",
            hereSince = "25 December 2022",
            otherInfo = mapOf(
                "Ingredients" to "Sugar, Fat, Salt",
                "Description" to "Straight From the cow",
                "Expires On" to "31 December 2023"
            )
        ),
        JarInfo(
            jarId = "36314134",
            jarOwnerName = "Baz",
            jarOwnerUserId = "2435234",
            jarContentName = "Butter",
            hereSince = "22 October 2022",
            otherInfo = mapOf(
                "Ingredients" to "Milk, Fat, Salt",
                "Description" to "Straight From the cow"
            )
        ),
        JarInfo(
            jarId = "36314134",
            jarOwnerName = "Didi",
            jarOwnerUserId = "236324234",
            jarContentName = "Elderberry Tea",
            hereSince = "17 October 2022",
            otherInfo = mapOf(
                "Ingredients" to "Elderberries, Tumeric, Peppers",
                "Description" to "Makes you feel great!"
            )
        ),
        JarInfo(
            jarId = "36314134",
            jarOwnerName = "Aisling",
            jarOwnerUserId = "32y7435",
            jarContentName = "Weetabix",
            hereSince = "12 November 2022",
            otherInfo = mapOf(
                "Ingredients" to "Wheat, Sugar, Honey",
                "Description" to "Great for brekie"
            )
        ),
        JarInfo(
            jarId = "36314134",
            jarOwnerName = "Yeva",
            jarOwnerUserId = "9823423532",
            jarContentName = "Sour Creme",
            hereSince = "14 November 2022",
            otherInfo = mapOf(
                "Ingredients" to "Milk, Cream, Sugar",
                "Description" to "I add this to EVERYTHING",
                "Expires on" to "19 December 2022"
            )
        ),
    )

    fun getJarById(jarId:String) {}
    fun getJarsByUser(userId:String) {}

    fun createJarById(jarId:String) {}
    fun updateJarById(jarId:String) {}
    fun deleteJarById(jarId:String) {}
}