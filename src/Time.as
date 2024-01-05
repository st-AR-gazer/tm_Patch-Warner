int absolute(int value) {
    return value < 0 ? -value : value;
}

void updateCountdown(int &countdownTime, int duration, int startTime) {
    int elapsedTime = Time::Now - startTime;
    int expectedCountdown = duration - elapsedTime;

    if (absolute(countdownTime - expectedCountdown) > 10) {
        countdownTime = expectedCountdown;
    }

    if (countdownTime <= 0) {
        startTime = -1;
    }
}
