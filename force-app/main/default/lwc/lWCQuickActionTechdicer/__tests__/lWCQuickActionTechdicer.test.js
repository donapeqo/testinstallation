import { createElement } from 'lwc';
import LWCQuickActionTechdicer from 'c/lWCQuickActionTechdicer';

describe('c-lwc-quick-action-techdicer', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('TODO: test case generated by CLI command, please fill in test logic', () => {
        // Arrange
        const element = createElement('c-lwc-quick-action-techdicer', {
            is: LWCQuickActionTechdicer
        });

        // Act
        document.body.appendChild(element);

        // Assert
        // const div = element.shadowRoot.querySelector('div');
        expect(1).toBe(1);
    });
});