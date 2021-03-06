module RubyLangMailingListCustomizationMailer
  def issue_add(user, issue)
    m = super(user, issue)

    m.header[:from] = issue.author.mail
    m.header[:subject] = "[#{issue.project.name} #{issue.tracker.name}##{issue.id}] #{issue.subject}"
    m
  end

  def issue_edit(user, journal)
    issue = journal.issue
    m = super(user, journal)

    m.header[:from] = journal.user.mail
    m.header[:subject] = "[#{issue.project.name} #{issue.tracker.name}##{issue.id}] #{issue.subject}"
    m
  end

  def mail(headers={}, &block)
    headers[:bcc] = (headers[:bcc] || []).concat((headers[:cc] || []))
    headers[:cc] = []
    locale = headers[:to].to_s.include?('ruby-dev') ? :ja : :en
    I18n.with_locale(locale) { super(headers) }
  end
end

Mailer.class_eval do
  prepend RubyLangMailingListCustomizationMailer
end
