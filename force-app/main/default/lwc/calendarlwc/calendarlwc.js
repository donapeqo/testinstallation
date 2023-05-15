import { LightningElement, track } from 'lwc';

export default class Calendar extends LightningElement {
    @track currentMonth = '';
    @track weeks = [];

    connectedCallback() {
        this.currentMonth = this.getMonthName(new Date().getMonth());
        this.generateCalendar();
    }

    getMonthName(monthIndex) {
        const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        return monthNames[monthIndex];
    }

    generateCalendar() {
        const today = new Date();
        const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
        const lastDayOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);
        const firstDayOfWeek = firstDayOfMonth.getDay();
        const lastDayOfWeek = lastDayOfMonth.getDay();
        const daysInMonth = lastDayOfMonth.getDate();
        const daysInLastMonth = new Date(today.getFullYear(), today.getMonth(), 0).getDate();
        const weeks = [];
        let week = [];
        let day = 0;

        for (let i = 0; i < 7; i++) {
            if (i < firstDayOfWeek) {
                day = daysInLastMonth - firstDayOfWeek + i + 1;
                week.push({ number: day, className: 'inactive' });
            } else if (i >= daysInMonth + firstDayOfWeek) {
                day = i - daysInMonth - firstDayOfWeek + 1;
                week.push({ number: day, className: 'inactive' });
            } else {
                day = i - firstDayOfWeek + 1;
                week.push({ number: day, className: '' });
            }
        }

        weeks.push(week);

        for (let i = 1; i < 6; i++) {
            week = [];

            for (let j = 0; j < 7; j++) {
                if (day < daysInMonth) {
                    day++;
                    week.push({ number: day, className: '' });
                } else {
                    day = 1;
                    week.push({ number: day, className: 'inactive' });
                    break;
                }
            }

            weeks.push(week);

            if (day === daysInMonth) {
                break;
            }
        }

        this.weeks = weeks;
    }

    handlePrevMonth() {
        const currentDate = new Date();
        const currentMonth = currentDate.getMonth();
        currentDate.setMonth(currentMonth - 1);
        this.currentMonth = this.getMonthName(currentDate.getMonth());
        this.generateCalendar();
    }

    handleNextMonth() {
        const currentDate = new Date();
        const currentMonth = currentDate.getMonth();
        currentDate.setMonth(currentMonth + 1);
    }
}