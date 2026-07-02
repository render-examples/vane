import OpenAILLM from '../openai/openaiLLM';
import { Message } from '@/lib/types';
import { ChatCompletionMessageParam } from 'openai/resources/index.mjs';

class AnthropicLLM extends OpenAILLM {
  // Anthropic's OpenAI-compatible endpoint rejects empty text content blocks.
  // The researcher emits assistant turns with empty content alongside tool
  // calls, so coalesce "" to null (which Anthropic accepts) for this provider.
  convertToOpenAIMessages(messages: Message[]): ChatCompletionMessageParam[] {
    return super.convertToOpenAIMessages(messages).map((msg) =>
      msg.role === 'assistant' && !msg.content ? { ...msg, content: null } : msg,
    );
  }
}

export default AnthropicLLM;
