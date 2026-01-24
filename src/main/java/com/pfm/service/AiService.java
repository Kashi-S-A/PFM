package com.pfm.service;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import reactor.core.publisher.Flux;

@Service
public class AiService {

    private final ChatClient chatClient;

    public AiService(ChatClient.Builder builder) {
        this.chatClient = builder.build();
    }

    public String ask(String prompt) {
        return chatClient
                .prompt()
                .system("""
                		You are a Personal Finance Assistant.
                		Currency is INR (₹).
                		Answer strictly based on provided data.
                		If user asks for advice, give advice. Otherwise answer only the question.
                		""")
                .user(prompt)
                .call()
                .content();
    }
    
 // STREAMING
    public Flux<String> askStream(String prompt) {
        return chatClient
                .prompt()
                .system("""
                		You are a Personal Finance Assistant.
                		Currency is INR (₹).
                		Answer strictly based on provided data.
                		If user asks for advice, give advice. Otherwise answer only the question.
                		""")
                .user(prompt)
                .stream()
                .content();
    }
}