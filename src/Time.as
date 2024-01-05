int PreviousTime = 0;
int CountdownTime;

bool startCountdown = false;

void time() {
    print(CountdownTime);
    if (startCountdown) {
        print(CountdownTime + " aaaaa");

        uint CurrentTime = Time::get_Now();

        if (CountdownTime > 0) {
            CountdownTime -= CurrentTime - PreviousTime;
            if (CountdownTime < 0) CountdownTime = 0;
        }

        PreviousTime = CurrentTime;

        if (CountdownTime == 0) startCountdown = false;
    }
}
