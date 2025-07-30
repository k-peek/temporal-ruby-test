# Temporal Workflow Testing

A simple demo showcasing Temporal workflow patterns using Ruby on Rails.

1. **Simple Purchase** - Basic sequential workflow: payment → confirmation email
2. **Cancellation Flow** - Using signals to message into the flow.

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

## 📚 Learn More

- [Temporal Documentation](https://docs.temporal.io/)
- [Temporal Ruby SDK](https://github.com/temporalio/sdk-ruby)
