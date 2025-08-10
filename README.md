# Temporal Workflow Testing

A simple demo showcasing Temporal workflow patterns using Ruby on Rails.

1. **Simple Purchase** - Basic sequential workflow: payment → confirmation email
2. **Cancellation Flow** - Using signals to message into the flow. Try sending signals into the flow like this:
<img width="1616" height="764" alt="Screenshot 2025-08-10 at 7 34 35 PM" src="https://github.com/user-attachments/assets/7c74862e-9aed-48cf-94e0-5d7e6b430ec1" />


## Quick Start via Devbox


1. **Install devbox**:
   ```bash
   curl -fsSL https://get.jetify.com/devbox | bash
   ```

2. **Clone the project**:
   ```bash
   git clone https://github.com/k-peek/temporal-ruby-test
   ```

2. **Setup and start all services**:
   ```bash
   devbox shell
   ```
   
   This automatically starts:
   - Temporal server (localhost:8233)
   - Rails Temporal worker
   - Rails web server (localhost:3001)

3. **Open the demo**:
   ```
   http://localhost:3001
   ```

4. **Try the workflows**:
   - Use the carousel interface to navigate between demos
   - Monitor progress in the Temporal UI at http://localhost:8233

## Instructions without devbox

TODO. Install temporal & ruby. Run servers. See scripts/start-services.sh

## 📚 Learn More

- [Temporal Documentation](https://docs.temporal.io/)
- [Temporal Ruby SDK](https://github.com/temporalio/sdk-ruby)
