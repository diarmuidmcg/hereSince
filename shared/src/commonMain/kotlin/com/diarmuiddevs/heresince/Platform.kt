package com.diarmuiddevs.heresince

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform